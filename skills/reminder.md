# Skill: Criar Lembretes

## Uso
Quando o usuário pedir para criar um lembrete.

## Instruções
1. Extraia:
   - **O quê**: Descrição do lembrete
   - **Quando**: Data e hora (ou "em X minutos/dias")
   - **Prioridade**: Alta/Média/Baixa
2. Formato da resposta:
   ```
   ⏰ Lembrete Criado!
   
   **O quê:** [descrição]
   **Quando:** [data/hora formatada]
   **Prioridade:** [Alta/Média/Baixa]
   
   Lembrete salvo. Eu te aviso no horário!
   ```
3. Se o usuário fornecer uma data relativa ("em 30 minutos", "amanhã"), calcule a data absoluta

## Exemplo
Usuário: "Me lembra da reunião em 2 horas"
Agente: Formata e confirma o lembrete