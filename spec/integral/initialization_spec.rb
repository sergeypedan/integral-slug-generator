# frozen_string_literal: true

RSpec.describe Integral::SlugGenerator do

  subject { described_class.new(uniqueness_checker: uniqueness_checker) }

  context "with only `uniqueness_checker` argument" do
    context "when lambda" do
      let(:uniqueness_checker) { lambda { true } }
      it do expect { subject }.not_to raise_exception end
    end

    context "when something else" do
      let(:uniqueness_checker) { "lala" }
      it do expect { subject }.to raise_exception ArgumentError end
    end
  end

end
