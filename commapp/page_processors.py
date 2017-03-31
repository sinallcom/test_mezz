from django import forms
from django.http import HttpResponseRedirect
from mezzanine.pages.page_processors import processor_for
from .models import CommunityPage
from django.contrib.auth.models import User,Group

@processor_for(CommunityPage)
def author_form(request, page):
    #  users = User.objects.all().order_by('-id')[:5]

    users = list(User.objects.all().order_by('-id')[:5])
    for user in users:
        user.grouplist = list(Group.objects.raw('SELECT * FROM auth_group, auth_user_groups WHERE auth_group.id=auth_user_groups.group_id and auth_user_groups.user_id = ' + str(user.id) +' order by name desc'))

    return  {"users": users}
