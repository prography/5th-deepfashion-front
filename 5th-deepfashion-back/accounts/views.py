from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets, status
from accounts.models import CustomUser
from accounts.serializers import AccountSerializer
from rest_framework.response import Response
from rest_framework.views import APIView

class AccountViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list` and `detail` actions.
    """
    queryset = CustomUser.objects.all()
    serializer_class = AccountSerializer


class Logout(APIView):
    def get(self, request, format=None):
        # simply delete the token to force a login
        request.user.auth_token.delete()
        return Response(status=status.HTTP_200_OK)
