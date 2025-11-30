import django_filters
from .models import *

class ItemCarrinhoFilter(django_filters.FilterSet):
    quantidade_min = django_filters.NumberFilter(field_name='quantidade', lookup_expr='gte')
    quantidade_max = django_filters.NumberFilter(field_name='quantidade', lookup_expr='lte')

    class Meta:
        model = ItemCarrinho
        fields = ['carrinho', 'prato', 'quantidade']

class CarrinhoFilter(django_filters.FilterSet):
    
    class Meta:
        model = Carrinho
        fields = ['id','usuario']
