from rest_framework import viewsets, permissions
from .models import Cardapio, Carrinho, ItemCarrinho
from .serializers import CardapioSerializer, CarrinhoSerializer, ItemCarrinhoSerializer
from rest_framework.decorators import action


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

from .models import Carrinho, ItemCarrinho, Cardapio
from .serializers import *

class CarrinhoViewSet(viewsets.ModelViewSet):
    queryset = Carrinho.objects.all()
    serializer_class = CarrinhoSerializer

    def get_queryset(self):
        user = self.request.user
        if user.is_authenticated:
            return Carrinho.objects.filter(usuario=user)
        return Carrinho.objects.none()

    def perform_create(self, serializer):
        serializer.save(usuario=self.request.user)

    
    
    
    @action(detail=True, methods=['post'])
    def adicionar(self, request, pk=None):
        carrinho = self.get_object()
        prato_id = request.data.get('prato')
        quantidade = int(request.data.get('quantidade', 1))

        prato = get_object_or_404(Cardapio, id=prato_id)

        item, created = ItemCarrinho.objects.get_or_create(
            carrinho=carrinho,
            prato=prato,
            defaults={'quantidade': quantidade}
        )

        if not created:
            item.quantidade += quantidade
            item.save()

        return Response(ItemCarrinhoSerializer(item).data)

    
    
    
    @action(detail=True, methods=['post'])
    def remover(self, request, pk=None):
        carrinho = self.get_object()
        item_id = request.data.get('item_id')

        item = get_object_or_404(ItemCarrinho, id=item_id, carrinho=carrinho)
        item.delete()

        return Response({"detail": "Item removido"}, status=200)

    
    
    
    @action(detail=True, methods=['post'])
    def atualizar(self, request, pk=None):
        carrinho = self.get_object()
        item_id = request.data.get('item_id')
        quantidade = request.data.get('quantidade')

        item = get_object_or_404(ItemCarrinho, id=item_id, carrinho=carrinho)
        item.quantidade = quantidade
        item.save()

        return Response(ItemCarrinhoSerializer(item).data)

    
    
    
    @action(detail=True, methods=['post'])
    def limpar(self, request, pk=None):
        carrinho = self.get_object()
        carrinho.itens.all().delete()
        
        return Response({"detail": "Carrinho esvaziado"}, status=200)
