using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Npgsql;

namespace Hastane_Kayit_Sistemi1
{
    
    public partial class Form3 : Form
    {
        string globalHastaId = "";
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost;port=5432;Database=HastaKayit;user Id=postgres;password=1234");
        public Form3()
        {
            InitializeComponent();
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Form4 frm = new Form4();
            frm.Show();
            this.Hide();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            baglanti.Open();

            string sorguHasta = "SELECT hastaid,hastaadi ,sifre FROM public.hasta;";
            NpgsqlCommand pcmd = new NpgsqlCommand(sorguHasta, baglanti);
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorguHasta, baglanti);

            DataSet ds = new DataSet();
            da.Fill(ds);
            NpgsqlDataReader reader = pcmd.ExecuteReader();
            bool kontrol = false;
            while (reader.Read())
            {
                if (reader["hastaadi"].ToString()==textBox1.Text)
                {
                    if (reader["sifre"].ToString()==textBox2.Text)
                    {
                        globalHastaId= reader["hastaid"].ToString();
                        Form2 frm = new Form2(globalHastaId);
                        frm.Show();
                        this.Hide();
                    }
                    else
                    {
                        label3.Text = "Hatalı şifre tekrar giriniz";
                        textBox2.Text = "";
                    }
                    kontrol = true;
                }
            }
            if (kontrol==false)
            {
                label3.Text = "Böyle bir kullanıcı yok";
                textBox1.Text = "";
                textBox2.Text = "";
            }
            baglanti.Close();
            reader.Close();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }
    }
}
