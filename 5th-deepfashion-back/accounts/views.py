from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
from accounts.models import CustomUser
from accounts.serializers import AccountSerializer


class AccountViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list` and `detail` actions.
    """
    queryset = CustomUser.objects.all()
    serializer_class = AccountSerializer
