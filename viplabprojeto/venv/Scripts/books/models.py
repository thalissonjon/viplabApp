from django.db import models

# Create your models here.

class Videos(models.Model):
    video = models.FileField(upload_to='videos_uploaded')