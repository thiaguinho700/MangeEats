from rest_framework import viewsets, permissions
from .models import Cardapio, Carrinho, ItemCarrinho
from .serializers import CardapioSerializer, CarrinhoSerializer, ItemCarrinhoSerializer
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response


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
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Carrinho.objects.filter(usuario=self.request.user)

    def perform_create(self, serializer):
        serializer.save(usuario=self.request.user)

    @action(detail=True, methods=['post'])
    def adicionar(self, request, pk=None):
        carrinho = self.get_object()
        prato_id = request.data.get('prato_id')
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

        return Response(ItemCarrinhoSerializer(item).data, status=201)

