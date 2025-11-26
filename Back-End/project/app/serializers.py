from rest_framework import serializers
from .models import Carrinho, ItemCarrinho, Cardapio

class CardapioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cardapio
        fields = '__all__'


class ItemCarrinhoSerializer(serializers.ModelSerializer):
    prato = CardapioSerializer(read_only=True)

    class Meta:
        model = ItemCarrinho
        fields = ['id', 'prato', 'quantidade']


class ItemCarrinhoWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = ItemCarrinho
        fields = ['id', 'prato', 'quantidade']


class CarrinhoSerializer(serializers.ModelSerializer):
    usuario = serializers.PrimaryKeyRelatedField(read_only=True) 
    itens = ItemCarrinhoSerializer(many=True, read_only=True)

    class Meta:
        model = Carrinho
        fields = ['id', 'usuario', 'itens']
