from django.core.management.base import BaseCommand
from django.core.files.storage import default_storage
from public_map.models import TreeImage, UrbanTree
import os
from django.conf import settings


class Command(BaseCommand):
    help = 'Verify and fix tree images - checks if all image files exist and fixes broken references'

    def add_arguments(self, parser):
        parser.add_argument(
            '--fix',
            action='store_true',
            help='Fix issues by removing entries without image files',
        )

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('[CHECK] Checking tree images...'))
        self.stdout.write(f'[MEDIA_ROOT] {settings.MEDIA_ROOT}')
        self.stdout.write(f'[MEDIA_URL] {settings.MEDIA_URL}')
        self.stdout.write('')

        # Check TreeImage entries
        tree_images = TreeImage.objects.all()
        total = tree_images.count()
        broken = []
        valid = []

        self.stdout.write(f'[INFO] Total images in database: {total}\n')

        for tree_image in tree_images:
            if tree_image.image:
                file_path = os.path.join(settings.MEDIA_ROOT, tree_image.image.name)
                exists = os.path.exists(file_path) or default_storage.exists(tree_image.image.name)

                if exists:
                    valid.append(tree_image)
                    self.stdout.write(
                        self.style.SUCCESS(f'[OK] {tree_image.tree.code} - {tree_image.image.name}')
                    )
                else:
                    broken.append(tree_image)
                    self.stdout.write(
                        self.style.ERROR(f'[BROKEN] {tree_image.tree.code} - MISSING: {tree_image.image.name}')
                    )
            else:
                broken.append(tree_image)
                self.stdout.write(
                    self.style.ERROR(f'[BROKEN] {tree_image.tree.code} - NO IMAGE FILE SET')
                )

        self.stdout.write('')
        self.stdout.write(f'[OK] Working images: {len(valid)}')
        self.stdout.write(f'[BROKEN] Broken images: {len(broken)}')

        if broken and options['fix']:
            self.stdout.write(self.style.WARNING(f'\n[FIX] Fixing {len(broken)} broken images...'))
            for tree_image in broken:
                tree_code = tree_image.tree.code
                tree_image.delete()
                self.stdout.write(
                    self.style.SUCCESS(f'  [DELETED] Removed broken image for tree {tree_code}')
                )
            self.stdout.write(self.style.SUCCESS('[SUCCESS] Done!'))
        elif broken:
            self.stdout.write(
                self.style.WARNING('\n[TIP] Run with --fix to remove broken images')
            )

        # Check UrbanTree.image field compatibility
        self.stdout.write('\n[CHECK] Checking main images (UrbanTree.image):')
        trees = UrbanTree.objects.exclude(image='')
        for tree in trees:
            if tree.image:
                file_path = os.path.join(settings.MEDIA_ROOT, tree.image.name)
                exists = os.path.exists(file_path) or default_storage.exists(tree.image.name)
                if exists:
                    self.stdout.write(self.style.SUCCESS(f'[OK] {tree.code} - {tree.image.name}'))
                else:
                    self.stdout.write(self.style.ERROR(f'[BROKEN] {tree.code} - MISSING: {tree.image.name}'))
