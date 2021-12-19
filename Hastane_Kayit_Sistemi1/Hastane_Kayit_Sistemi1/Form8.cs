using Npgsql;
using System;
using System.Windows.Forms;
namespace Hastane_Kayit_Sistemi1
{
    public partial class Form8 : Form
    {
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost;port=5432;Database=HastaKayit;user Id=postgres;password=1234");

        public Form8(string asistan)
        {
            InitializeComponent();
        }

        private void Form8_Load(object sender, EventArgs e)
        {

        }

        private void linkLabel2_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            baglanti.Open();
            string sorgu = "SELECT * FROM randevuekle(@p1,@p2 ,@p3,@p4,@p5);";
            NpgsqlCommand cmd = new NpgsqlCommand(sorgu,baglanti);
            cmd.Parameters.AddWithValue("@p1",textBox1.Text);
            cmd.Parameters.AddWithValue("@p2",textBox5.Text);
            cmd.Parameters.AddWithValue("@p3",int.Parse(textBox4.Text));
            cmd.Parameters.AddWithValue("@p4",textBox3.Text);
            cmd.Parameters.AddWithValue("@p5",int.Parse(textBox2.Text));
            cmd.ExecuteNonQuery();
            MessageBox.Show("Randevu Oluşturuldu");
            baglanti.Close();

        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            baglanti.Open();
            string sorgu = " INSERT INTO public.recete (\"receteid\",\"hastaid\",\"ilacadi\",\"doktorid\") VALUES (@p1,@2,@p3,@p4);";
            NpgsqlCommand cmd = new NpgsqlCommand(sorgu, baglanti);
            cmd.Parameters.AddWithValue("@p1", int.Parse(textBox6.Text));
            cmd.Parameters.AddWithValue("@p2",int.Parse( textBox7.Text));
            cmd.Parameters.AddWithValue("@p3", textBox8.Text);
            cmd.Parameters.AddWithValue("@p4", int.Parse(textBox9.Text));
          
            cmd.ExecuteNonQuery();
            MessageBox.Show("REÇETE OLUŞTU");
            baglanti.Close();
        }
    }
}
