from django.contrib import admin
from django.urls import path
from api import views
# from django.conf.urls import url

urlpatterns = [
    path('admin/', admin.site.urls),
    path('link/', views.submit_link, name='link'),
    # re_path('^$', views.index, name ='homepage')
]