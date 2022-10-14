shared_examples 'have timestamps' do
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(precision: 6, null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(precision: 6, null: false) }
end
