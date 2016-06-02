# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduce', '0003_auto_20150724_1002'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='生产信息',
            unique_together=set([('日期', '名称', '单位')]),
        ),
    ]
