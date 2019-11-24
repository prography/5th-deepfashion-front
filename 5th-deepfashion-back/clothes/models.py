from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()
# user 들의 옷 모델


# summer, all, spring/fall, winter types
class SeasonType(models.Model):
    name = models.TextField()

    def __str__(self):
        return self.name



# jean, jogger, padding types
class CategoryType(models.Model):
    name = models.TextField()

    def __str__(self):
        return self.name

class PartType(models.Model):
    name = models.TextField()

    def __str__(self):
        return self.name



class Clothing(models.Model):
    style = models.ForeignKey('accounts.Style', on_delete=models.SET_NULL, null=True)
    name = models.TextField()
    color = models.TextField()
    owner = models.ForeignKey(User, related_name='clothings', on_delete=models.CASCADE)
    season = models.ForeignKey(SeasonType, on_delete=models.SET_NULL, null=True)
    part = models.ForeignKey(PartType, on_delete=models.SET_NULL, null=True)
    category = models.ForeignKey(CategoryType, on_delete=models.SET_NULL, null=True)
    
    def __str__(self):
        return self.name



class PostImage(models.Model):
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    clothing = models.ForeignKey(Clothing, related_name='images', on_delete=models.CASCADE, null=True)
    image = models.ImageField()

    def __str__(self):
        return str(self.owner) + "'s " + self.clothing.name
