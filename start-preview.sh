#!/bin/bash

# Script para iniciar o preview do projeto no Emergent
# Corrige o problema de HTTP 502 configurando o servidor para aceitar conexões externas

echo "🚀 Iniciando servidor de desenvolvimento..."

# Parar processos existentes
pkill -f vite 2>/dev/null || true

# Aguardar um momento
sleep 2

# Iniciar servidor de desenvolvimento
echo "📦 Instalando dependências (se necessário)..."
npm install --silent

echo "🔧 Iniciando Vite dev server..."
npm run dev &
DEV_PID=$!

# Aguardar servidor inicializar
sleep 5

# Verificar se está rodando
if curl -s http://localhost:5173 > /dev/null; then
    echo "✅ Servidor de desenvolvimento funcionando!"
    echo "🌐 Acesse em: http://localhost:5173"
    echo "📱 Network: http://$(hostname -I | awk '{print $1}'):5173"
else
    echo "❌ Erro ao iniciar servidor de desenvolvimento"
    exit 1
fi

# Criar build de produção
echo "🏗️  Criando build de produção..."
npm run build

echo "🚀 Iniciando preview de produção..."
npm run preview &
PREVIEW_PID=$!

# Aguardar servidor de produção inicializar
sleep 3

# Verificar se está rodando
if curl -s http://localhost:4173 > /dev/null; then
    echo "✅ Servidor de produção funcionando!"
    echo "🌐 Preview: http://localhost:4173"
    echo "📱 Network: http://$(hostname -I | awk '{print $1}'):4173"
else
    echo "❌ Erro ao iniciar servidor de produção"
fi

echo ""
echo "🎉 Servidores iniciados com sucesso!"
echo "📋 Status dos serviços:"
echo "   • Desenvolvimento: PID $DEV_PID (porta 5173)"
echo "   • Produção: PID $PREVIEW_PID (porta 4173)"
echo ""
echo "💡 Para parar os serviços: pkill -f vite"