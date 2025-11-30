from rest_framework import serializers
from .models import Carrinho, ItemCarrinho, Cardapio
from django.contrib.auth.models import User
    

class CardapioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cardapio
        fields = '__all__'


class ItemCarrinhoSerializer(serializers.ModelSerializer):
    prato = CardapioSerializer(read_only=True)

    class Meta:
        model = ItemCarrinho
        fields = '__all__'


class ItemCarrinhoWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = ItemCarrinho
        fields = '__all__'


class CarrinhoSerializer(serializers.ModelSerializer):
    usuario = serializers.PrimaryKeyRelatedField(queryset=User.objects.all()) 
   
    class Meta:
        model = Carrinho
        fields = '__all__'

