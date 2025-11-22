from rest_framework import serializers
from .models import Cardapio, Carrinho, ItemCarrinho


class CardapioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cardapio
        fields = '__all__'


class ItemCarrinhoSerializer(serializers.ModelSerializer):
    prato = CardapioSerializer(read_only=True)
    prato_id = serializers.PrimaryKeyRelatedField(
        queryset=Cardapio.objects.all(),
        write_only=True,
        source='prato'
    )

    class Meta:
        model = ItemCarrinho
        fields = ['id', 'prato', 'prato_id', 'quantidade']


class CarrinhoSerializer(serializers.ModelSerializer):
    itens = ItemCarrinhoSerializer(many=True, read_only=True)
    total = serializers.SerializerMethodField()

    class Meta:
        model = Carrinho
        fields = ['id', 'usuario', 'itens', 'total']
        read_only_fields = ['usuario']


    def get_total(self, obj):
        return sum(
            item.prato.preco * item.quantidade
            for item in obj.itens.all()
        )
