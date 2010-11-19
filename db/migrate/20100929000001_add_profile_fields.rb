class AddProfileFields < ActiveRecord::Migration
  def self.up
    add_column :profiles, :jbxx_khmc, :string
    add_column :profiles, :jbxx_province,   :integer
    add_column :profiles, :jbxx_city, :integer
    add_column :profiles, :jbxx_dz,   :string
    add_column :profiles, :jbxx_dh, :string
    add_column :profiles, :jbxx_cz, :string
    add_column :profiles, :jbxx_clsj, :string
    add_column :profiles, :jbxx_zczj, :string
    add_column :profiles, :jbxx_jyfs, :string
    add_column :profiles, :jbxx_ywrs, :integer
    add_column :profiles, :jbxx_scrs, :integer
    add_column :profiles, :jbxx_gsrs, :integer

    add_column :profiles, :gsgk_zjl_xm, :string
    add_column :profiles, :gsgk_zjl_dh, :string
    add_column :profiles, :gsgk_cw_xm, :string
    add_column :profiles, :gsgk_cw_dh, :string
    add_column :profiles, :gsgk_yxzj_xm, :string
    add_column :profiles, :gsgk_yxzj_dh, :string
    add_column :profiles, :gsgk_sh_xm, :string
    add_column :profiles, :gsgk_sh_dh, :string

    add_column :profiles, :jyqk_dlpp1, :string
    add_column :profiles, :jyqk_yxqk1, :string
    add_column :profiles, :jyqk_nxqk1, :string
    add_column :profiles, :jyqk_bz1,   :string
    add_column :profiles, :jyqk_dlpp2, :string
    add_column :profiles, :jyqk_yxqk2, :string
    add_column :profiles, :jyqk_nxqk2, :string
    add_column :profiles, :jyqk_bz2,   :string
    add_column :profiles, :jyqk_dlpp3, :string
    add_column :profiles, :jyqk_yxqk3, :string
    add_column :profiles, :jyqk_nxqk3, :string
    add_column :profiles, :jyqk_bz3,   :string
    add_column :profiles, :jyqk_dlpp4, :string
    add_column :profiles, :jyqk_yxqk4, :string
    add_column :profiles, :jyqk_nxqk4, :string
    add_column :profiles, :jyqk_bz4,   :string

    add_column :profiles, :shqk_nl,    :string
    add_column :profiles, :shqk_bz,    :string

    add_column :profiles, :jy_jgfm,    :string
    add_column :profiles, :jy_xyed,    :string
    add_column :profiles, :jy_ggfm,    :string
    add_column :profiles, :jy_shfm,    :string
    add_column :profiles, :jy_scxz,    :string
  end

  def self.down
    remove_column :profiles, :jbxx_khmc
    remove_column :profiles, :jbxx_province
    remove_column :profiles, :jbxx_city
    remove_column :profiles, :jbxx_dz
    remove_column :profiles, :jbxx_dh
    remove_column :profiles, :jbxx_cz
    remove_column :profiles, :jbxx_clsj
    remove_column :profiles, :jbxx_zczj
    remove_column :profiles, :jbxx_jyfs
    remove_column :profiles, :jbxx_ywrs
    remove_column :profiles, :jbxx_scrs
    remove_column :profiles, :jbxx_gsrs

    remove_column :profiles, :gsgk_zjl_xm
    remove_column :profiles, :gsgk_zjl_dh
    remove_column :profiles, :gsgk_cw_xm
    remove_column :profiles, :gsgk_cw_dh
    remove_column :profiles, :gsgk_yxzj_xm
    remove_column :profiles, :gsgk_yxzj_dh
    remove_column :profiles, :gsgk_sh_xm
    remove_column :profiles, :gsgk_sh_dh

    remove_column :profiles, :jyqk_dlpp1
    remove_column :profiles, :jyqk_yxqk1
    remove_column :profiles, :jyqk_nxqk1
    remove_column :profiles, :jyqk_bz1
    remove_column :profiles, :jyqk_dlpp2
    remove_column :profiles, :jyqk_yxqk2
    remove_column :profiles, :jyqk_nxqk2
    remove_column :profiles, :jyqk_bz2
    remove_column :profiles, :jyqk_dlpp3
    remove_column :profiles, :jyqk_yxqk3
    remove_column :profiles, :jyqk_nxqk3
    remove_column :profiles, :jyqk_bz3
    remove_column :profiles, :jyqk_dlpp4
    remove_column :profiles, :jyqk_yxqk4
    remove_column :profiles, :jyqk_nxqk4
    remove_column :profiles, :jyqk_bz4

    remove_column :profiles, :shqk_nl
    remove_column :profiles, :shqk_bz

    remove_column :profiles, :jy_jgfm
    remove_column :profiles, :jy_xyed
    remove_column :profiles, :jy_ggfm
    remove_column :profiles, :jy_shfm
    remove_column :profiles, :jy_scxz
  end
end