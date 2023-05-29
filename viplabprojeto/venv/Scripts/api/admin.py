from django.contrib import admin
from .models import video

# Register your models here.
@admin.register(video)

class videoAdmin(admin.ModelAdmin):
    list_display = ['url']