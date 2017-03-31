from django.contrib import admin
from mezzanine.pages.admin import PageAdmin
from .models import CommunityPage

admin.site.register(CommunityPage, PageAdmin)