# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduce', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='提单',
            name='实际装车bbl',
            field=models.FloatField(null=True, blank=True),
        ),
    ]
