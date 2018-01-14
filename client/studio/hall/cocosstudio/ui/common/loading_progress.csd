<GameFile>
  <PropertyGroup Name="loading_progress" Type="Node" ID="51169352-7149-4e0a-be4f-8f793be68370" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Node" Tag="110" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="img_loadingbg" ActionTag="-368635951" Tag="115" IconVisible="False" LeftMargin="-640.0000" RightMargin="-640.0000" TopMargin="-68.7117" BottomMargin="55.7117" Scale9Enable="True" LeftEage="8" RightEage="8" TopEage="2" BottomEage="2" Scale9OriginX="8" Scale9OriginY="2" Scale9Width="10" Scale9Height="4" ctype="ImageViewObjectData">
            <Size X="1280.0000" Y="13.0000" />
            <Children>
              <AbstractNodeData Name="bar_loading" ActionTag="-1063816882" Tag="114" IconVisible="False" TopMargin="2.9999" BottomMargin="2.0001" ProgressInfo="61" ctype="LoadingBarObjectData">
                <Size X="1280.0000" Y="8.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position Y="6.0001" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition Y="0.4615" />
                <PreSize X="1.0000" Y="0.6154" />
                <ImageFileData Type="Normal" Path="hall/loading/loadibg_bar.png" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" />
            <Position Y="55.7117" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="MarkedSubImage" Path="hall/loading/loadibg_bg.png" Plist="hall/loading.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="node_tips" ActionTag="-753660733" Tag="123" IconVisible="True" TopMargin="-27.4423" BottomMargin="27.4423" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="text_percent" ActionTag="115341096" Tag="113" IconVisible="False" LeftMargin="-24.0000" RightMargin="-24.0000" TopMargin="-75.3446" BottomMargin="47.3446" FontSize="24" LabelText="65%" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="48.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position Y="61.3446" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/mnjcy.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="text_tips" ActionTag="1647613182" Tag="111" IconVisible="False" LeftMargin="-79.0000" RightMargin="-80.0000" TopMargin="-13.9999" BottomMargin="-14.0001" FontSize="24" LabelText="资源加载中......" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="159.0000" Y="28.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="-79.0000" Y="-0.0001" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/mnjcy.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="text_counter" ActionTag="-2047538849" Tag="112" IconVisible="False" LeftMargin="83.9969" RightMargin="-170.9969" TopMargin="-13.9999" BottomMargin="-14.0001" FontSize="24" LabelText="100/100" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="87.0000" Y="28.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="170.9969" Y="-0.0001" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/mnjcy.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position Y="27.4423" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>