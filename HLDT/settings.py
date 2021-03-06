import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.9/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'aj2o)&gfkz*twkq7_f_-4igws$ep==a(2l-3=e2vde1-kct07i'

# SECURITY WARNING: don't run with debug turned on in production!
# DEBUG = True
DEBUG = False

ALLOWED_HOSTS = ['*']
INTERNAL_IPS = ('127.0.0.1',)

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'Home',
    'Account',
    'ProcessProduction',
    'EquipmentMaintenance',
    'QHSE',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    # 'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'HLDT.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [
            os.path.join(BASE_DIR, 'templates'),
        ],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
    # {
    #     'BACKEND': 'django.template.backends.jinja2.Jinja2',
    #     'APP_DIRS': True,
    #     'DIRS': [
    #         os.path.join(BASE_DIR, 'Jinja2'),
    #     ],
    #     "OPTIONS": {
    #         'environment': 'HLDT.jinja2Env.environment',
    #     },
    # },
]

WSGI_APPLICATION = 'HLDT.wsgi.application'
# Database
DATABASES = {
    # 'default': {
    #     'ENGINE': 'django.db.backends.sqlite3',
    #     'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    # }
    'default': {
        # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'HLD',
        'USER': 'operator',
        'PASSWORD': '5302469',
        # 'HOST': '127.0.0.1',
        # 'HOST': 'localhost',
        # 'HOST': '10.30.29.80',
        'HOST': '192.168.0.111',
        'PORT': '2012',
    }
}


# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# LANGUAGE_CODE = 'en-us'
LANGUAGE_CODE = 'zh-hans'
# TIME_ZONE = 'UTC'
TIME_ZONE = 'Asia/Shanghai'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.9/howto/static-files/

STATIC_URL = '/static/'
STATICFILES_DIRS = (
    os.path.join(BASE_DIR, "static"),
)
# STATIC_ROOT = os.path.join(BASE_DIR, 'static')
STATIC_ROOT = '/var/www/static'

MEDIA_URL = '/public/'
# MEDIA_ROOT = '/media/WE2T/public'
# MEDIA_ROOT = 'f:\\public'
MEDIA_ROOT = os.path.join(BASE_DIR, "../")


# %(name)s Logger的名字
# %(levelno)s 数字形式的日志级别
# %(levelname)s 文本形式的日志级别
# %(pathname)s 调用日志输出函数的模块的完整路径名，可能没有
# %(filename)s 调用日志输出函数的模块的文件名
# %(module)s 调用日志输出函数的模块名
# %(funcName)s 调用日志输出函数的函数名
# %(lineno)d 调用日志输出函数的语句所在的代码行
# %(created)f 当前时间，用UNIX标准的表示时间的浮 点数表示
# %(relativeCreated)d 输出日志信息时的，自Logger创建以 来的毫秒数
# %(asctime)s 字符串形式的当前时间。默认格式是 “2003-07-08 16:49:45,896”。逗号后面的是毫秒
# %(thread)d 线程ID。可能没有
# %(threadName)s 线程名。可能没有
# %(process)d 进程ID。可能没有
# %(message)s用户输出的消息
# LOGGER_ROOT = '/tmp'
LOGGER_ROOT = '../log/'

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    #日志格式
    'formatters': {
        'simple': {
            'format': '[%(lineno)d] [%(module)s:%(funcName)s] [%(levelname)s]- %(message)s'
        },
        'standard': {
            'format': '[%(asctime)s]  [%(lineno)d:%(name)s:%(module)s:%(funcName)s] [%(levelname)s]- %(message)s'
        },
        'verbose': {
            'format': '[%(asctime)s] [%(threadName)s:%(thread)d] [%(lineno)d:%(name)s:%(module)s:%(funcName)s] [%(levelname)s]- %(message)s'
        }
    },
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': os.path.join(LOGGER_ROOT, 'HLDT_debug.log'),
            'formatter': 'standard',
        },
        'error': {
            'level': 'ERROR',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': os.path.join(LOGGER_ROOT, 'HLDT_error.log'),
            'maxBytes': 1024 * 1024 * 8,
            'backupCount': 2,
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': False
        },
    }
}
