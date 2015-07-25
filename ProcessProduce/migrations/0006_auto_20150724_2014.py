# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduce', '0005_auto_20150724_1024'),
    ]

    operations = [
        migrations.AlterField(
            model_name='生产信息',
            name='id',
            field=models.AutoField(primary_key=True, serialize=False, auto_created=True, verbose_name='ID'),
        ),
    ]
