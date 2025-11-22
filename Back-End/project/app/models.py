
from django.contrib.auth.models import User
from django.db import models

class Cardapio(models.Model):
    TIPOS = [
        ('DOCE','Doce'),
        ('SALGADO','Salgado'),
        ('MASSA','Massa'),
    ]

    nome_prato = models.CharField(max_length=255, unique=True)
    descricao = models.CharField(max_length=255)
    preco = models.DecimalField(max_digits=10, decimal_places=2)
    imagem = models.FileField(upload_to='pratos_images')
    prato_tipo = models.CharField(max_length=50, choices=TIPOS, default='MASSA')

    def __str__(self):
        return self.nome_prato

class Carrinho(models.Model):
    usuario = models.ForeignKey(User, on_delete=models.CASCADE, related_name='carrinho')
    
    def __str__(self):
        return f"Carrinho de {self.usuario.username}"

class ItemCarrinho(models.Model):
    carrinho = models.ForeignKey(Carrinho, on_delete=models.CASCADE, related_name='itens')
    prato = models.ForeignKey(Cardapio, on_delete=models.CASCADE)
    quantidade = models.PositiveIntegerField(default=1)

    def __str__(self):
        return f"{self.quantidade}x {self.prato.nome_prato}"
