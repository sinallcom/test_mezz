# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('commapp', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='communitypage',
            options={'ordering': ('_order',), 'verbose_name': 'Community Page', 'verbose_name_plural': 'Community Pages'},
        ),
        migrations.RemoveField(
            model_name='communitypage',
            name='add_toc',
        ),
    ]
