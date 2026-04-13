'use client';

import { useMemo, useState } from 'react';
import { Bar, BarChart, Cell, Pie, PieChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from 'recharts';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { useFinanceStore } from '@/hooks/use-finance-store';
import { investmentAllocation, toCurrency } from '@/lib/finance';

const colors = ['#22c55e', '#14b8a6', '#eab308', '#f97316', '#a855f7'];

export default function InvestimentosPage() {
  const { investments, setInvestments, loaded } = useFinanceStore();
  const [form, setForm] = useState({
    assetType: '',
    assetName: '',
    investedValue: 0,
    quantity: 0,
    averagePrice: 0,
    contributionDate: '',
    notes: ''
  });

  const allocation = investmentAllocation(investments);
  const contributions = useMemo(
    () => investments.map((item) => ({ month: item.contributionDate.slice(0, 7), valor: item.investedValue })),
    [investments]
  );

  const total = investments.reduce((acc, item) => acc + item.investedValue, 0);

  if (!loaded) return <p>Carregando...</p>;

  return (
    <div className="space-y-4">
      <Card className="grid gap-3 md:grid-cols-4">
        <Input placeholder="Tipo do ativo" value={form.assetType} onChange={(e) => setForm((prev) => ({ ...prev, assetType: e.target.value }))} />
        <Input placeholder="Nome do ativo" value={form.assetName} onChange={(e) => setForm((prev) => ({ ...prev, assetName: e.target.value }))} />
        <Input type="number" placeholder="Valor investido" value={form.investedValue} onChange={(e) => setForm((prev) => ({ ...prev, investedValue: Number(e.target.value) }))} />
        <Input type="number" placeholder="Quantidade" value={form.quantity} onChange={(e) => setForm((prev) => ({ ...prev, quantity: Number(e.target.value) }))} />
        <Input type="number" placeholder="Preço médio" value={form.averagePrice} onChange={(e) => setForm((prev) => ({ ...prev, averagePrice: Number(e.target.value) }))} />
        <Input type="date" value={form.contributionDate} onChange={(e) => setForm((prev) => ({ ...prev, contributionDate: e.target.value }))} />
        <Input className="md:col-span-2" placeholder="Observações" value={form.notes} onChange={(e) => setForm((prev) => ({ ...prev, notes: e.target.value }))} />
        <Button
          onClick={() => {
            setInvestments((prev) => [{ ...form, id: crypto.randomUUID() }, ...prev]);
            setForm({ assetType: '', assetName: '', investedValue: 0, quantity: 0, averagePrice: 0, contributionDate: '', notes: '' });
          }}
        >
          Cadastrar investimento
        </Button>
      </Card>

      <Card>
        <p className="text-sm text-zinc-400">Total investido</p>
        <p className="text-2xl font-bold">{toCurrency(total)}</p>
      </Card>

      <section className="grid gap-4 xl:grid-cols-2">
        <Card className="h-[320px]">
          <h3 className="mb-4 font-semibold">Distribuição percentual da carteira</h3>
          <ResponsiveContainer width="100%" height="90%">
            <PieChart>
              <Pie data={allocation} dataKey="value" nameKey="name" outerRadius={90} label>
                {allocation.map((_, index) => (
                  <Cell key={index} fill={colors[index % colors.length]} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </Card>

        <Card className="h-[320px]">
          <h3 className="mb-4 font-semibold">Evolução de aportes</h3>
          <ResponsiveContainer width="100%" height="90%">
            <BarChart data={contributions}>
              <XAxis dataKey="month" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="valor" fill="#22c55e" />
            </BarChart>
          </ResponsiveContainer>
        </Card>
      </section>
    </div>
  );
}
