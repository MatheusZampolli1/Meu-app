import { FinancialEntry, Investment } from '@/types/finance';

export const initialEntries: FinancialEntry[] = [
  {
    id: '1',
    date: '2026-04-01',
    type: 'receita',
    category: 'Salário',
    description: 'Salário mensal',
    value: 12000,
    account: 'Conta Corrente',
    paymentMethod: 'Transferência',
    status: 'confirmado',
    notes: ''
  },
  {
    id: '2',
    date: '2026-04-03',
    type: 'gasto',
    category: 'Moradia',
    description: 'Aluguel',
    value: 3200,
    account: 'Conta Corrente',
    paymentMethod: 'PIX',
    status: 'confirmado',
    notes: ''
  },
  {
    id: '3',
    date: '2026-04-05',
    type: 'aporte',
    category: 'Investimentos',
    description: 'Aporte Tesouro Selic',
    value: 1500,
    account: 'Corretora',
    paymentMethod: 'TED',
    status: 'confirmado',
    notes: ''
  },
  {
    id: '4',
    date: '2026-03-20',
    type: 'gasto',
    category: 'Lazer',
    description: 'Viagem curta',
    value: 980,
    account: 'Cartão',
    paymentMethod: 'Crédito',
    status: 'confirmado',
    notes: ''
  }
];

export const initialInvestments: Investment[] = [
  {
    id: 'i1',
    assetType: 'Renda Fixa',
    assetName: 'Tesouro Selic 2029',
    investedValue: 10000,
    quantity: 10,
    averagePrice: 1000,
    contributionDate: '2026-01-10',
    notes: 'Reserva de emergência'
  },
  {
    id: 'i2',
    assetType: 'Ações',
    assetName: 'PETR4',
    investedValue: 6400,
    quantity: 200,
    averagePrice: 32,
    contributionDate: '2026-02-15',
    notes: ''
  }
];
