<GameFile>
  <PropertyGroup Name="game_list_item_node" Type="Node" ID="40b8375b-9538-4d10-a37f-c49d829d7967" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="7" Speed="0.1333" ActivedAnimationName="icon_action">
        <Timeline ActionTag="1772266098" Property="FileData">
          <TextureFrame FrameIndex="0" Tween="False">
            <TextureFile Type="Normal" Path="hall/common/game_icon_action_1.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="1" Tween="False">
            <TextureFile Type="Normal" Path="hall/common/game_icon_action_2.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="2" Tween="False">
            <TextureFile Type="Normal" Path="hall/common/game_icon_action_3.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="3" Tween="False">
            <TextureFile Type="Normal" Path="hall/common/game_icon_action_4.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="4" Tween="False">
            <TextureFile Type="Normal" Path="hall/common/game_icon_action_5.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="5" Tween="False">
            <TextureFile Type="Normal" Path="hall/common/game_icon_action_6.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="6" Tween="False">
            <TextureFile Type="Normal" Path="hall/common/game_icon_action_7.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="7" Tween="False">
            <TextureFile Type="Normal" Path="hall/common/game_icon_action_8.png" Plist="" />
          </TextureFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="icon_action" StartIndex="0" EndIndex="7">
          <RenderColor A="255" R="192" G="192" B="192" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" Tag="243" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="panel_bg" ActionTag="-226254407" Tag="196" IconVisible="False" LeftMargin="-66.0000" RightMargin="-66.0000" TopMargin="-66.0000" BottomMargin="-66.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="132.0000" Y="132.0000" />
            <Children>
              <AbstractNodeData Name="img_icon" ActionTag="1993706338" Tag="244" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftEage="15" RightEage="15" TopEage="15" BottomEage="15" Scale9OriginX="15" Scale9OriginY="15" Scale9Width="102" Scale9Height="102" ctype="ImageViewObjectData">
                <Size X="132.0000" Y="132.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="66.0000" Y="66.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="1.0000" Y="1.0000" />
                <FileData Type="Normal" Path="weile/icon_default.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="action_node" ActionTag="1772266098" Tag="62" IconVisible="False" LeftMargin="-9.0000" RightMargin="-9.0000" TopMargin="-9.0000" BottomMargin="-9.0000" ctype="SpriteObjectData">
                <Size X="150.0000" Y="150.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="66.0000" Y="66.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="1.1364" Y="1.1364" />
                <FileData Type="Normal" Path="hall/common/game_icon_action_6.png" Plist="" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="panel" Visible="False" ActionTag="-770593139" Tag="170" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" TouchEnable="True" ClipAble="False" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="90.0000" LeftEage="29" RightEage="29" TopEage="29" BottomEage="29" Scale9OriginX="29" Scale9OriginY="29" Scale9Width="74" Scale9Height="74" ctype="PanelObjectData">
                <Size X="132.0000" Y="132.0000" />
                <Children>
                  <AbstractNodeData Name="img_gq" ActionTag="800295416" Tag="172" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="23.0000" RightMargin="23.0000" TopMargin="23.0000" BottomMargin="23.0000" LeftEage="28" RightEage="28" TopEage="28" BottomEage="28" Scale9OriginX="28" Scale9OriginY="28" Scale9Width="30" Scale9Height="30" ctype="ImageViewObjectData">
                    <Size X="86.0000" Y="86.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="66.0000" Y="66.0000" />
                    <Scale ScaleX="1.3000" ScaleY="1.3000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.6515" Y="0.6515" />
                    <FileData Type="MarkedSubImage" Path="hall/common/loading_circle_bg.png" Plist="hall/common.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="txt" ActionTag="-1385945990" Tag="171" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="39.0000" RightMargin="39.0000" TopMargin="51.0000" BottomMargin="51.0000" FontSize="26" LabelText="等待" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="54.0000" Y="30.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="66.0000" Y="66.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.4091" Y="0.2273" />
                    <FontResource Type="Normal" Path="fonts/mnjcy.ttf" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="66.0000" Y="66.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="1.0000" Y="1.0000" />
                <FileData Type="MarkedSubImage" Path="hall/common/room_mask.png" Plist="hall/common.plist" />
                <SingleColor A="255" R="0" G="0" B="0" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="txt_name" ActionTag="1801637240" Tag="50" IconVisible="False" LeftMargin="-45.0000" RightMargin="-45.0000" TopMargin="75.0000" BottomMargin="-105.0000" FontSize="30" LabelText="游戏名" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
            <Size X="90.0000" Y="30.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position Y="-90.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>