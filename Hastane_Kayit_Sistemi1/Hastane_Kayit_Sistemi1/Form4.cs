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
    public partial class Form4 : Form
    {
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost;port=5432;Database=HastaKayit;user Id=postgres;password=1234");
        public Form4()
        {
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand cmd = new NpgsqlCommand("insert into public.hasta (hastaadi,hastasoyadi,sifre) values (@p1,@p2,@p3);",baglanti);
            cmd.Parameters.AddWithValue("@p1",textBox1.Text);
            cmd.Parameters.AddWithValue("@p2", textBox2.Text);
            cmd.Parameters.AddWithValue("@p3", textBox3.Text);
            cmd.ExecuteNonQuery();
         

            baglanti.Close();
            MessageBox.Show("Kayıt oluşturuldu");
            Form3 frm = new Form3();
            frm.Show();
            this.Hide();
           
        }
    }
}
