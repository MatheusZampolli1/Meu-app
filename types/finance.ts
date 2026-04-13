export type EntryType = 'gasto' | 'receita' | 'investimento' | 'aporte' | 'resgate';

export interface FinancialEntry {
  id: string;
  date: string;
  type: EntryType;
  category: string;
  description: string;
  value: number;
  account: string;
  paymentMethod: string;
  status: string;
  notes: string;
}

export interface Investment {
  id: string;
  assetType: string;
  assetName: string;
  investedValue: number;
  quantity: number;
  averagePrice: number;
  contributionDate: string;
  notes: string;
}
