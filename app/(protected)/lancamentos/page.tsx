'use client';

import { useMemo, useState } from 'react';
import Papa from 'papaparse';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Select } from '@/components/ui/select';
import { Table, Td, Th } from '@/components/ui/table';
import { useFinanceStore } from '@/hooks/use-finance-store';
import { toCurrency } from '@/lib/finance';
import { EntryType, FinancialEntry } from '@/types/finance';

const entryTypes: EntryType[] = ['gasto', 'receita', 'investimento', 'aporte', 'resgate'];

const emptyForm: Omit<FinancialEntry, 'id'> = {
  date: '',
  type: 'gasto',
  category: '',
  description: '',
  value: 0,
  account: '',
  paymentMethod: '',
  status: 'pendente',
  notes: ''
};

export default function LancamentosPage() {
  const { entries, setEntries, loaded } = useFinanceStore();
  const [form, setForm] = useState(emptyForm);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [textFilter, setTextFilter] = useState('');
  const [typeFilter, setTypeFilter] = useState('todos');
  const [categoryFilter, setCategoryFilter] = useState('todos');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [sortKey, setSortKey] = useState<keyof FinancialEntry>('date');
  const [asc, setAsc] = useState(false);

  const categories = Array.from(new Set(entries.map((entry) => entry.category)));

  const filtered = useMemo(() => {
    return entries
      .filter((entry) => (typeFilter === 'todos' ? true : entry.type === typeFilter))
      .filter((entry) => (categoryFilter === 'todos' ? true : entry.category === categoryFilter))
      .filter((entry) => (startDate ? entry.date >= startDate : true))
      .filter((entry) => (endDate ? entry.date <= endDate : true))
      .filter((entry) => {
        const q = textFilter.toLowerCase();
        return !q || `${entry.description} ${entry.notes} ${entry.category}`.toLowerCase().includes(q);
      })
      .sort((a, b) => {
        const left = a[sortKey];
        const right = b[sortKey];
        if (left < right) return asc ? -1 : 1;
        if (left > right) return asc ? 1 : -1;
        return 0;
      });
  }, [entries, typeFilter, categoryFilter, startDate, endDate, textFilter, sortKey, asc]);

  const totals = {
    receitas: filtered.filter((item) => item.type === 'receita').reduce((acc, item) => acc + item.value, 0),
    gastos: filtered.filter((item) => item.type === 'gasto').reduce((acc, item) => acc + item.value, 0)
  };

  function saveEntry() {
    if (editingId) {
      setEntries((prev) => prev.map((entry) => (entry.id === editingId ? { ...form, id: editingId } : entry)));
    } else {
      setEntries((prev) => [{ ...form, id: crypto.randomUUID() }, ...prev]);
    }
    setForm(emptyForm);
    setEditingId(null);
  }

  function editEntry(entry: FinancialEntry) {
    setEditingId(entry.id);
    setForm({ ...entry, value: Number(entry.value) });
  }

  function deleteEntry(id: string) {
    setEntries((prev) => prev.filter((entry) => entry.id !== id));
  }

  function exportCsv() {
    const csv = Papa.unparse(entries);
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.setAttribute('download', 'lancamentos.csv');
    link.click();
  }

  function importCsv(file: File) {
    Papa.parse<FinancialEntry>(file, {
      header: true,
      complete: (result) => {
        const valid = result.data
          .filter((row) => row.description)
          .map((row) => ({ ...row, id: crypto.randomUUID(), value: Number(row.value) }));
        setEntries((prev) => [...valid, ...prev]);
      }
    });
  }

  if (!loaded) return <p>Carregando...</p>;

  return (
    <div className="space-y-4">
      <Card className="grid gap-3 md:grid-cols-4">
        <Input type="date" value={form.date} onChange={(e) => setForm((f) => ({ ...f, date: e.target.value }))} />
        <Select value={form.type} onChange={(e) => setForm((f) => ({ ...f, type: e.target.value as EntryType }))}>
          {entryTypes.map((type) => (
            <option key={type}>{type}</option>
          ))}
        </Select>
        <Input placeholder="Categoria" value={form.category} onChange={(e) => setForm((f) => ({ ...f, category: e.target.value }))} />
        <Input placeholder="Descrição" value={form.description} onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))} />
        <Input type="number" placeholder="Valor" value={form.value} onChange={(e) => setForm((f) => ({ ...f, value: Number(e.target.value) }))} />
        <Input placeholder="Conta" value={form.account} onChange={(e) => setForm((f) => ({ ...f, account: e.target.value }))} />
        <Input placeholder="Forma de pagamento" value={form.paymentMethod} onChange={(e) => setForm((f) => ({ ...f, paymentMethod: e.target.value }))} />
        <Input placeholder="Status" value={form.status} onChange={(e) => setForm((f) => ({ ...f, status: e.target.value }))} />
        <Input className="md:col-span-3" placeholder="Observações" value={form.notes} onChange={(e) => setForm((f) => ({ ...f, notes: e.target.value }))} />
        <Button onClick={saveEntry}>{editingId ? 'Salvar edição' : 'Adicionar lançamento'}</Button>
      </Card>

      <Card className="grid gap-3 md:grid-cols-6">
        <Input placeholder="Busca por texto" value={textFilter} onChange={(e) => setTextFilter(e.target.value)} />
        <Select value={typeFilter} onChange={(e) => setTypeFilter(e.target.value)}>
          <option value="todos">Todos os tipos</option>
          {entryTypes.map((type) => (
            <option key={type}>{type}</option>
          ))}
        </Select>
        <Select value={categoryFilter} onChange={(e) => setCategoryFilter(e.target.value)}>
          <option value="todos">Todas categorias</option>
          {categories.map((category) => (
            <option key={category}>{category}</option>
          ))}
        </Select>
        <Input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
        <Input type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} />
        <div className="flex gap-2">
          <Button variant="secondary" onClick={exportCsv}>Exportar CSV</Button>
          <Input type="file" accept=".csv" onChange={(e) => e.target.files?.[0] && importCsv(e.target.files[0])} />
        </div>
      </Card>

      <Card>
        <div className="mb-3 flex flex-wrap gap-4 text-sm">
          <p>Receitas: <span className="font-semibold text-green-400">{toCurrency(totals.receitas)}</span></p>
          <p>Gastos: <span className="font-semibold text-red-400">{toCurrency(totals.gastos)}</span></p>
          <p>Saldo: <span className="font-semibold">{toCurrency(totals.receitas - totals.gastos)}</span></p>
        </div>
        <div className="overflow-x-auto">
          <Table>
            <thead>
              <tr>
                {(['date', 'type', 'category', 'description', 'value', 'account', 'paymentMethod', 'status', 'notes'] as (keyof FinancialEntry)[]).map((key) => (
                  <Th
                    key={key}
                    onClick={() => {
                      if (sortKey === key) setAsc((value) => !value);
                      else {
                        setSortKey(key);
                        setAsc(true);
                      }
                    }}
                  >
                    {key}
                  </Th>
                ))}
                <Th>Ações</Th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((entry) => (
                <tr key={entry.id}>
                  <Td>{entry.date}</Td>
                  <Td>{entry.type}</Td>
                  <Td>{entry.category}</Td>
                  <Td>{entry.description}</Td>
                  <Td>{toCurrency(entry.value)}</Td>
                  <Td>{entry.account}</Td>
                  <Td>{entry.paymentMethod}</Td>
                  <Td>{entry.status}</Td>
                  <Td>{entry.notes}</Td>
                  <Td>
                    <div className="flex gap-2">
                      <Button size="sm" variant="secondary" onClick={() => editEntry(entry)}>Editar</Button>
                      <Button size="sm" variant="destructive" onClick={() => deleteEntry(entry.id)}>Excluir</Button>
                    </div>
                  </Td>
                </tr>
              ))}
            </tbody>
          </Table>
        </div>
      </Card>
    </div>
  );
}
