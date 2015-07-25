# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduce', '0002_auto_20150714_1445'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='生产信息',
            unique_together=set([('日期', '名称', '单位', '备注')]),
        ),
    ]
