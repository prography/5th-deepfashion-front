from django.shortcuts import render
from rest_framework.parsers import FileUploadParser
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status, viewsets, permissions, generics, permissions
from .serializers import ImageSerializer, ClothingSerializer
from .models import Clothing
from .permissions import is_owner



class ImageUploadView(APIView):
    parser_class = (FileUploadParser,)

    def post(self, request, *args, **kwargs):

        image_serializer = ImageSerializer(data=request.data)

        if image_serializer.is_valid() and request.user == Clothing.objects.get(pk=request.data["clothing"]).owner:
        # if image_serializer.is_valid():
            image_serializer.save()
            return Response(image_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(image_serializer.errors, status=status.HTTP_400_BAD_REQUEST)



# only for admin, testin purposes
class AdminClothingList(generics.ListCreateAPIView):
    queryset = Clothing.objects.all()
    serializer_class = ClothingSerializer
    permission_classes = [permissions.IsAdminUser]


# get individual clothing, only works for owners
class ClothingDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Clothing.objects.all()
    serializer_class = ClothingSerializer
    permission_classes = [is_owner]

# get the list of all clothes a specific user has
class UserClothingList(generics.ListCreateAPIView):
    serializer_class = ClothingSerializer
    queryset = Clothing.objects.all()
    permission_classes = [is_owner]

    def get_queryset(self):
        """
        This view should return a list of all the clothes
        for the currently authenticated user.
        """
        user = self.request.user
        return Clothing.objects.filter(owner=user)
