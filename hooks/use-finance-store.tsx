'use client';

import { createContext, useContext, type Dispatch, type ReactNode, type SetStateAction } from 'react';
import { initialEntries, initialInvestments } from '@/data/mockData';
import { useLocalStorage } from '@/hooks/use-local-storage';
import { FinancialEntry, Investment } from '@/types/finance';

interface FinanceStore {
  entries: FinancialEntry[];
  setEntries: Dispatch<SetStateAction<FinancialEntry[]>>;
  investments: Investment[];
  setInvestments: Dispatch<SetStateAction<Investment[]>>;
  loaded: boolean;
}

const FinanceContext = createContext<FinanceStore | null>(null);

export function FinanceProvider({ children }: { children: ReactNode }) {
  const [entries, setEntries, entriesLoaded] = useLocalStorage<FinancialEntry[]>('finance_entries', initialEntries);
  const [investments, setInvestments, investmentsLoaded] = useLocalStorage<Investment[]>(
    'finance_investments',
    initialInvestments
  );

  return (
    <FinanceContext.Provider value={{ entries, setEntries, investments, setInvestments, loaded: entriesLoaded && investmentsLoaded }}>
      {children}
    </FinanceContext.Provider>
  );
}

export function useFinanceStore() {
  const context = useContext(FinanceContext);
  if (!context) throw new Error('useFinanceStore precisa estar dentro de FinanceProvider');
  return context;
}
