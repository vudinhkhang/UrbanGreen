from datetime import date

from django.contrib.auth.models import User
from django.test import TestCase
from django.urls import reverse

from .models import MaintenanceLog, TreeSpecies, UrbanTree


class MaintenancePermissionTests(TestCase):
	def setUp(self):
		self.admin = User.objects.create_user(
			username='admin_test',
			password='adminpass123',
			is_staff=True,
			is_active=True,
		)
		self.user = User.objects.create_user(
			username='user_test',
			password='userpass123',
			is_staff=False,
			is_active=True,
		)
		self.species = TreeSpecies.objects.create(name='Bang')
		self.tree = UrbanTree.objects.create(
			species=self.species,
			code='TREE001',
			height=5.0,
			status='TOT',
			latitude=10.123,
			longitude=106.123,
			address='Test Address',
		)

	def test_employee_can_create_maintenance_from_tree_detail(self):
		self.client.login(username='user_test', password='userpass123')
		before_count = MaintenanceLog.objects.count()

		response = self.client.post(
			reverse('tree_detail', args=[self.tree.id]),
			{
				'add_maintenance': '1',
				'date': date.today().strftime('%Y-%m-%d'),
				'action': 'KIEM_TRA',
				'performer': 'User Test',
				'note': 'Operational task',
			},
		)

		self.assertEqual(response.status_code, 302)
		self.assertEqual(response.url, reverse('tree_detail', args=[self.tree.id]))
		self.assertEqual(MaintenanceLog.objects.count(), before_count + 1)

	def test_employee_can_access_tree_add_page(self):
		self.client.login(username='user_test', password='userpass123')
		response = self.client.get(reverse('tree_add'))
		self.assertEqual(response.status_code, 200)

	def test_employee_can_call_bulk_maintenance_api(self):
		self.client.login(username='user_test', password='userpass123')
		response = self.client.post(
			reverse('bulk_maintenance'),
			data='{"tree_ids": [%d], "performer": "User", "action": "KIEM_TRA", "date": "%s"}' % (
				self.tree.id,
				date.today().strftime('%Y-%m-%d'),
			),
			content_type='application/json',
		)

		self.assertEqual(response.status_code, 200)
		self.assertEqual(MaintenanceLog.objects.count(), 1)

	def test_employee_can_access_maintenance_but_not_admin_pages(self):
		self.client.login(username='user_test', password='userpass123')

		maintenance_response = self.client.get(reverse('maintenance_list'))
		report_response = self.client.get(reverse('dashboard'))
		users_response = self.client.get(reverse('admin_users'))

		self.assertEqual(maintenance_response.status_code, 200)
		self.assertEqual(report_response.status_code, 302)
		self.assertEqual(report_response.url, reverse('home'))
		self.assertEqual(users_response.status_code, 302)
		self.assertEqual(users_response.url, reverse('home'))

	def test_admin_can_access_management_pages(self):
		self.client.login(username='admin_test', password='adminpass123')

		maintenance_response = self.client.get(reverse('maintenance_list'))
		report_response = self.client.get(reverse('dashboard'))
		users_response = self.client.get(reverse('admin_users'))

		self.assertEqual(maintenance_response.status_code, 200)
		self.assertEqual(report_response.status_code, 200)
		self.assertEqual(users_response.status_code, 200)
