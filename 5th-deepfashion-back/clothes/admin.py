from django.contrib import admin

# Register your models here.
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin
from .models import SeasonType, CategoryType, Clothing, PostImage, PartType


# class CustomUserAdmin(UserAdmin):
#     model = CustomUser
#     list_display = ['email', 'username','gender' ]

admin.site.register(Clothing)
admin.site.register(CategoryType)
admin.site.register(SeasonType)
admin.site.register(PartType)
admin.site.register(PostImage)
