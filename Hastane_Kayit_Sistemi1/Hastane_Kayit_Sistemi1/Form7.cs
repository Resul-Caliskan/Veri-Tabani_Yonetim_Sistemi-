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
    public partial class Form7 : Form
    {
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost;port=5432;Database=HastaKayit;user Id=postgres;password=1234");
        string globalasistanid = "";
        public Form7()
        {
            InitializeComponent();
        }

        private void Form7_Load(object sender, EventArgs e)
        {
 
        }

        private void button1_Click(object sender, EventArgs e)
        {
            baglanti.Open();

            string sorgu = "SELECT asistanid,asistanadi ,sifre FROM hastaneler.asistan;";
            NpgsqlCommand pcmd = new NpgsqlCommand(sorgu, baglanti);
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);

            DataSet ds = new DataSet();
            da.Fill(ds);
            NpgsqlDataReader reader = pcmd.ExecuteReader();
            bool kontrol = false;
            while (reader.Read())
            {
                if (reader["asistanadi"].ToString() == textBox1.Text)
                {
                    if (reader["sifre"].ToString() == textBox2.Text)
                    {
                        globalasistanid = reader["asistanid"].ToString();
                        Form8 frm = new Form8(globalasistanid);
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
            if (kontrol == false)
            {
                label3.Text = "Böyle bir kullanıcı yok";
                textBox1.Text = "";
                textBox2.Text = "";
            }
            baglanti.Close();
            reader.Close();
           
        }
    }
}
