from rest_framework import viewsets, permissions
from .models import Cardapio, Carrinho, ItemCarrinho
from .serializers import CardapioSerializer, CarrinhoSerializer, ItemCarrinhoSerializer


class CardapioViewSet(viewsets.ModelViewSet):
    queryset = Cardapio.objects.all()
    serializer_class = CardapioSerializer
    # permission_classes = [permissions.AllowAny]


class ItemCarrinhoViewSet(viewsets.ModelViewSet):
    queryset = ItemCarrinho.objects.all()
    serializer_class = ItemCarrinhoSerializer


class CarrinhoViewSet(viewsets.ModelViewSet):
    queryset = Carrinho.objects.all()
    serializer_class = CarrinhoSerializer
