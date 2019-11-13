from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()
# Create your models here.
# user 들의 옷 모델


class ClothingType(models.Model):
    name = models.TextField()

class Clothing(models.Model):
    type = models.ForeignKey(ClothingType, on_delete=models.SET_NULL, null=True)
    name = models.TextField()
    color = models.TextField()
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
