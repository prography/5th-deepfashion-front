from django.urls import path
from .views import ImageUploadView
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.routers import DefaultRouter, SimpleRouter
from clothes import views

urlpatterns = [
    path('upload/', views.ImageUploadView.as_view()),
    path('admin/', views.AdminClothingList.as_view()),
    path('<int:pk>/', views.ClothingDetail.as_view()),
    path('', views.UserClothingList.as_view()),
]


router = SimpleRouter()
urlpatterns += router.urls


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL,
                          document_root=settings.MEDIA_ROOT)
