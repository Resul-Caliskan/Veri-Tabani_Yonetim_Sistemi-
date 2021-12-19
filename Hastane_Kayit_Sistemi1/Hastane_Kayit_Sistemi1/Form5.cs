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
    public partial class Form5 : Form
    {
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost;port=5432;Database=HastaKayit;user Id=postgres;password=1234");
        string hastaid = "";
        public Form5(string hasta)
        {
            hastaid = hasta;
            InitializeComponent();
        }

        private void Form5_Load(object sender, EventArgs e)
        {
            baglanti.Open();
            string sorgu = "SELECT * FROM public.randevular where \"rndid\" in (Select \"randid\" FROM \"public\".\"randevularim\" where \"hastaid\"="+hastaid+" )";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu,baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
            
            baglanti.Close();

        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Form1 frm = new Form1();
            frm.Show();
            this.Hide();

        }
    }
}
