from django import forms
from django.http import HttpResponseRedirect
from mezzanine.pages.page_processors import processor_for
from .models import CommunityPage
from django.contrib.auth.models import User

@processor_for(CommunityPage)
def author_form(request, page):
    users = User.objects.all().order_by('-id')[:5]
    return  {"users": users}
