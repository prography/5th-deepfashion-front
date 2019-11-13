from django.contrib import admin

# Register your models here.
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser, Style


# class CustomUserAdmin(UserAdmin):
#     model = CustomUser
#     list_display = ['email', 'username','gender' ]

admin.site.register(CustomUser)
admin.site.register(Style)
