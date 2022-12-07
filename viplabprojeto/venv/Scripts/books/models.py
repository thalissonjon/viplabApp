from django.db import models



# Create your models here.
class videos(models.Model):
    # username = models.CharField(max_length=30)
    video = models.FileField(upload_to='images')