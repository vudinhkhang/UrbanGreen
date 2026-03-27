from django.conf import settings


class RelaxNullOriginInDebugMiddleware:
    """Allow local dev requests from clients that send Origin: null.

    Some embedded/webview clients send a literal 'null' Origin header,
    which fails Django CSRF origin checks even with valid CSRF token.
    This middleware strips that header only in DEBUG mode.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if settings.DEBUG and request.META.get("HTTP_ORIGIN") == "null":
            request.META.pop("HTTP_ORIGIN", None)
        return self.get_response(request)
