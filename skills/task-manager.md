# Skill: Gerenciar Tarefas

## Uso
Quando o usuário pedir para criar, listar, atualizar ou deletar tarefas.

## Instruções
1. **Criar tarefa:**
   - Nome da tarefa
   - Descrição (opcional)
   - Prioridade: Alta/Média/Baixa
   - Prazo (opcional)
   - Tags/categorias

2. **Listar tarefas:**
   - Filtre por status: pendentes, concluídas, todas
   - Ordene por: prioridade, prazo, data de criação

3. **Atualizar tarefa:**
   - Mudar status (pendente → concluída)
   - Alterar prioridade
   - Adicionar notas

4. **Deletar tarefa:**
   - Confirme antes de deletar

## Formato de Resposta
```
✅ Tarefa Criada/Atualizada!

**ID:** #001
**Tarefa:** [descrição]
**Status:** [Pendente/Concluída]
**Prioridade:** [Alta/Média/Baixa]
**Prazo:** [data ou "Sem prazo"]
```

## Listagem
```
📋 Lista de Tarefas

**Pendentes (X):**
1. 🔴 #001 - [tarefa] (Alta)
2. 🟡 #002 - [tarefa] (Média)

**Concluídas (Y):**
✅ #003 - [tarefa]
```