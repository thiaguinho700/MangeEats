from rest_framework.routers import DefaultRouter
from .views import CardapioViewSet, ItemCarrinhoViewSet, CarrinhoViewSet

router = DefaultRouter()

router.register(r'cardapio', CardapioViewSet, basename="cardapio")
router.register(r'itemCarrinho', ItemCarrinhoViewSet, basename="item-carrinho")
router.register(r'carrinho', CarrinhoViewSet, basename="carrinho")

urlpatterns = router.urls
