from rest_framework import viewsets, permissions
from .models import Cardapio, Carrinho, ItemCarrinho
from .serializers import *
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from .filters import *

class CardapioViewSet(viewsets.ModelViewSet):
    queryset = Cardapio.objects.all()
    serializer_class = CardapioSerializer
    # permission_classes = [permissions.AllowAny]

class ItemCarrinhoViewSet(viewsets.ModelViewSet):
    queryset = ItemCarrinho.objects.all()
    serializer_class = ItemCarrinhoWriteSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_class = ItemCarrinhoFilter


class CarrinhoViewSet(viewsets.ModelViewSet):
    queryset = Carrinho.objects.all()
    serializer_class = CarrinhoSerializer
    filterset_class = CarrinhoFilter
    filter_backends = [DjangoFilterBackend]
    # permission_classes = [permissions.IsAuthenticated]  
