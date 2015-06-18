# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('Information', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='blog',
            name='ranking',
        ),
        migrations.RemoveField(
            model_name='blog',
            name='viewCount',
        ),
        migrations.RemoveField(
            model_name='message',
            name='Category',
        ),
    ]
