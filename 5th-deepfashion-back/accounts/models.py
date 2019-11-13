from django.db import models

# Create your models here.
from django.contrib.auth.models import AbstractUser

# user들 선호 스타일 모델, 댄디, 스트리트, 섹시, etc
class Style(models.Model):
    name = models.TextField()
    def __str__(self):
        return self.name

class CustomUser(AbstractUser):
    gender = models.TextField(null=True)
    styles = models.ManyToManyField(Style)
    
    def __str__(self):
        return self.username


