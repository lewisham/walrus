<GameFile>
  <PropertyGroup Name="menu_n" Type="Node" ID="60066138-1084-4db2-8c54-aafed4dc77d7" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="120" Speed="0.5000">
        <Timeline ActionTag="1594269002" Property="Alpha">
          <IntFrame FrameIndex="0" Value="0">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="60" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="120" Value="0">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="purse_animation" StartIndex="0" EndIndex="120">
          <RenderColor A="255" R="102" G="205" B="170" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" Tag="2" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="bk_menu" ActionTag="-1814450858" Alpha="204" Tag="65" IconVisible="False" RightMargin="-1332.0000" TopMargin="-44.0000" Scale9Enable="True" LeftEage="3" RightEage="3" TopEage="32" BottomEage="32" Scale9OriginX="3" Scale9OriginY="12" Scale9Width="10" Scale9Height="20" ctype="ImageViewObjectData">
            <Size X="1332.0000" Y="44.0000" />
            <Children>
              <AbstractNodeData Name="img_line" ActionTag="-1333288518" Tag="572" IconVisible="False" LeftMargin="1685.3467" RightMargin="-357.3467" TopMargin="-59.0326" BottomMargin="17.0326" LeftEage="1" RightEage="1" TopEage="28" BottomEage="28" Scale9OriginX="1" Scale9OriginY="28" Scale9Width="1" Scale9Height="46" ctype="ImageViewObjectData">
                <Size X="4.0000" Y="86.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1687.3467" Y="60.0326" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.2668" Y="1.3644" />
                <PreSize X="0.0030" Y="1.9545" />
                <FileData Type="MarkedSubImage" Path="hall/common/menu/bg_line.png" Plist="hall/common.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="MarkedSubImage" Path="hall/common/bg_bottom.png" Plist="hall/common.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="node_data" ActionTag="1430657801" Tag="210" IconVisible="True" LeftMargin="1255.0000" RightMargin="-1255.0000" TopMargin="-23.5848" BottomMargin="23.5848" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="btn_add_diamond" ActionTag="1950757760" Tag="215" IconVisible="False" LeftMargin="-400.0000" RightMargin="200.0000" TopMargin="-37.0000" BottomMargin="-23.0000" TouchEnable="True" ClipAble="False" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="200.0000" Y="60.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="-200.0000" Y="7.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <SingleColor A="255" R="255" G="255" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="ico_zuanshi" ActionTag="345022435" Tag="173" IconVisible="False" LeftMargin="-328.0000" RightMargin="280.0000" TopMargin="-15.0000" BottomMargin="-15.0000" ctype="SpriteObjectData">
                <Size X="48.0000" Y="30.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="-280.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="hall/common/pic_icon_zs.png" Plist="hall/common.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="txt_zuanshi" ActionTag="-615428522" Tag="174" IconVisible="False" LeftMargin="-225.2900" RightMargin="209.2900" TopMargin="-16.8191" BottomMargin="-16.1809" FontSize="32" LabelText="0" HorizontalAlignmentType="HT_Right" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="16.0000" Y="33.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="-209.2900" Y="0.3191" />
                <Scale ScaleX="1.0000" ScaleY="0.9297" />
                <CColor A="255" R="200" G="207" B="223" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="85" G="45" B="33" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_add_money" ActionTag="233861222" Tag="215" IconVisible="False" LeftMargin="-200.0000" TopMargin="-37.0000" BottomMargin="-23.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="200.0000" Y="60.0000" />
                <Children>
                  <AbstractNodeData Name="ico_beans" ActionTag="1524979660" Tag="24" IconVisible="False" LeftMargin="52.0000" RightMargin="100.0000" TopMargin="25.0000" BottomMargin="5.0000" ctype="SpriteObjectData">
                    <Size X="48.0000" Y="30.0000" />
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="100.0000" Y="20.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.3333" />
                    <PreSize X="0.2400" Y="0.5000" />
                    <FileData Type="MarkedSubImage" Path="hall/common/pic_icon_jd.png" Plist="hall/common.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="ico_add_money" ActionTag="-837947244" Tag="25" IconVisible="False" LeftMargin="60.0000" TopMargin="23.0000" BottomMargin="3.0000" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="110" Scale9Height="12" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="140.0000" Y="34.0000" />
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="200.0000" Y="20.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.0000" Y="0.3333" />
                    <PreSize X="0.7000" Y="0.5667" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="MarkedSubImage" Path="hall/common/menu/btn_add.png" Plist="hall/common.plist" />
                    <PressedFileData Type="MarkedSubImage" Path="hall/common/menu/btn_add.png" Plist="hall/common.plist" />
                    <NormalFileData Type="MarkedSubImage" Path="hall/common/menu/btn_add.png" Plist="hall/common.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="txt_beans" ActionTag="593212001" Tag="23" IconVisible="False" LeftMargin="124.0000" RightMargin="60.0000" TopMargin="23.5000" BottomMargin="3.5000" FontSize="32" LabelText="0" HorizontalAlignmentType="HT_Right" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="16.0000" Y="33.0000" />
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="140.0000" Y="20.0000" />
                    <Scale ScaleX="1.0000" ScaleY="0.9297" />
                    <CColor A="255" R="200" G="207" B="223" />
                    <PrePosition X="0.7000" Y="0.3333" />
                    <PreSize X="0.0800" Y="0.5500" />
                    <FontResource Type="Default" Path="" Plist="" />
                    <OutlineColor A="255" R="85" G="45" B="33" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position Y="7.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="1255.0000" Y="23.5848" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_menu" ActionTag="1035129288" Tag="470" IconVisible="False" LeftMargin="63.0000" RightMargin="-187.0000" TopMargin="-80.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="94" Scale9Height="58" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="124.0000" Y="80.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="125.0000" Y="40.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="MarkedSubImage" Path="hall/common/menu/btn_options.png" Plist="hall/common.plist" />
            <PressedFileData Type="MarkedSubImage" Path="hall/common/menu/btn_options.png" Plist="hall/common.plist" />
            <NormalFileData Type="MarkedSubImage" Path="hall/common/menu/btn_options.png" Plist="hall/common.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_czhi" ActionTag="821675249" VisibleForFrame="False" Tag="17" IconVisible="False" LeftMargin="416.0000" RightMargin="-540.0000" TopMargin="-80.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="94" Scale9Height="58" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="124.0000" Y="80.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="478.0000" Y="40.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="MarkedSubImage" Path="hall/common/menu/btn_czhi.png" Plist="hall/common.plist" />
            <PressedFileData Type="MarkedSubImage" Path="hall/common/menu/btn_czhi.png" Plist="hall/common.plist" />
            <NormalFileData Type="MarkedSubImage" Path="hall/common/menu/btn_czhi.png" Plist="hall/common.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_purse" ActionTag="1996462086" Tag="106" IconVisible="False" LeftMargin="416.0000" RightMargin="-540.0000" TopMargin="-80.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="94" Scale9Height="58" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="124.0000" Y="80.0000" />
            <Children>
              <AbstractNodeData Name="img_light" ActionTag="1594269002" Alpha="0" Tag="184" IconVisible="False" LeftMargin="-13.0000" RightMargin="-15.0000" TopMargin="-3.0000" BottomMargin="-9.0000" LeftEage="36" RightEage="36" TopEage="34" BottomEage="34" Scale9OriginX="36" Scale9OriginY="34" Scale9Width="80" Scale9Height="24" ctype="ImageViewObjectData">
                <Size X="152.0000" Y="92.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="63.0000" Y="37.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5081" Y="0.4625" />
                <PreSize X="1.2258" Y="1.1500" />
                <FileData Type="MarkedSubImage" Path="hall/common/btn_fd_light.png" Plist="hall/common.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="478.0000" Y="40.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="MarkedSubImage" Path="hall/common/btn_purse.png" Plist="hall/common.plist" />
            <PressedFileData Type="MarkedSubImage" Path="hall/common/btn_purse.png" Plist="hall/common.plist" />
            <NormalFileData Type="MarkedSubImage" Path="hall/common/btn_purse.png" Plist="hall/common.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_bag" ActionTag="669698771" Tag="27" IconVisible="False" LeftMargin="238.0000" RightMargin="-362.0000" TopMargin="-80.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="94" Scale9Height="58" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="124.0000" Y="80.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="300.0000" Y="40.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="MarkedSubImage" Path="hall/common/menu/btn_bag.png" Plist="hall/common.plist" />
            <PressedFileData Type="MarkedSubImage" Path="hall/common/menu/btn_bag.png" Plist="hall/common.plist" />
            <NormalFileData Type="MarkedSubImage" Path="hall/common/menu/btn_bag.png" Plist="hall/common.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="img_bubble" ActionTag="22547562" VisibleForFrame="False" Tag="362" IconVisible="False" LeftMargin="306.0000" RightMargin="-594.0000" TopMargin="-120.0000" BottomMargin="64.0000" LeftEage="95" RightEage="95" TopEage="18" BottomEage="18" Scale9OriginX="95" Scale9OriginY="18" Scale9Width="98" Scale9Height="20" ctype="ImageViewObjectData">
            <Size X="288.0000" Y="56.0000" />
            <Children>
              <AbstractNodeData Name="Text_1" ActionTag="711605586" Tag="363" IconVisible="False" LeftMargin="39.9837" RightMargin="38.0163" TopMargin="9.9894" BottomMargin="16.0106" FontSize="26" LabelText="您有可领取的奖励" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="210.0000" Y="30.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="144.9837" Y="31.0106" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="246" B="0" />
                <PrePosition X="0.5034" Y="0.5538" />
                <PreSize X="0.7292" Y="0.5357" />
                <FontResource Type="Normal" Path="fonts/mnjcy.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="450.0000" Y="92.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="MarkedSubImage" Path="hall/common/fd_info_bg.png" Plist="hall/common.plist" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>