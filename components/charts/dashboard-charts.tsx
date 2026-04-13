'use client';

import { Bar, BarChart, CartesianGrid, Legend, Line, LineChart, Pie, PieChart, ResponsiveContainer, Tooltip, XAxis, YAxis, Cell } from 'recharts';
import { Card } from '@/components/ui/card';

const colors = ['#22c55e', '#14b8a6', '#eab308', '#f97316', '#a855f7', '#3b82f6'];

export function DashboardCharts({
  expenseData,
  monthData,
  allocationData
}: {
  expenseData: { name: string; value: number }[];
  monthData: { month: string; receitas: number; gastos: number; patrimonio: number }[];
  allocationData: { name: string; value: number }[];
}) {
  return (
    <section className="grid gap-4 xl:grid-cols-2">
      <Card className="h-[320px]">
        <h3 className="mb-4 font-semibold">Gastos por categoria</h3>
        <ResponsiveContainer width="100%" height="90%">
          <PieChart>
            <Pie data={expenseData} dataKey="value" nameKey="name" outerRadius={90} label>
              {expenseData.map((_, index) => (
                <Cell key={index} fill={colors[index % colors.length]} />
              ))}
            </Pie>
            <Tooltip />
          </PieChart>
        </ResponsiveContainer>
      </Card>

      <Card className="h-[320px]">
        <h3 className="mb-4 font-semibold">Receitas vs Gastos por mês</h3>
        <ResponsiveContainer width="100%" height="90%">
          <BarChart data={monthData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="month" />
            <YAxis />
            <Tooltip />
            <Legend />
            <Bar dataKey="receitas" fill="#22c55e" />
            <Bar dataKey="gastos" fill="#f43f5e" />
          </BarChart>
        </ResponsiveContainer>
      </Card>

      <Card className="h-[320px]">
        <h3 className="mb-4 font-semibold">Evolução patrimonial</h3>
        <ResponsiveContainer width="100%" height="90%">
          <LineChart data={monthData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="month" />
            <YAxis />
            <Tooltip />
            <Line dataKey="patrimonio" stroke="#38bdf8" strokeWidth={2} />
          </LineChart>
        </ResponsiveContainer>
      </Card>

      <Card className="h-[320px]">
        <h3 className="mb-4 font-semibold">Distribuição dos investimentos</h3>
        <ResponsiveContainer width="100%" height="90%">
          <PieChart>
            <Pie data={allocationData} dataKey="value" nameKey="name" innerRadius={55} outerRadius={95}>
              {allocationData.map((_, index) => (
                <Cell key={index} fill={colors[index % colors.length]} />
              ))}
            </Pie>
            <Tooltip />
          </PieChart>
        </ResponsiveContainer>
      </Card>
    </section>
  );
}
