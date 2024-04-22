function Write_IES_TM27_SPDX_Spectrum(spec, filename, opts)
    arguments
        spec (1,1) struct 
        filename (1,1) string
        opts.Manufacturer (1,1) string = ''; % not required
        opts.CatalogNumber (1,1) string = ''; % not required
        opts.Description (1,1) string = 'description missing';
        opts.DocumentCreator (1,1) string = 'document creator missing';
        opts.Laboratory (1,1) string = ''; % not required
        opts.UniqueIdentifier (1,1) string = ''; % not required
        opts.ReportNumber (1,1) string = ''; % not required
        opts.ReportDate (1,1) string = ''; % not required
        opts.DocumentCreationDate (1,1) string = string(datetime('now','Format','yyyy-MM-dd'));
        opts.Comments (1,1) string = ''; % not required
        opts.SpectralQuantity (1,1) string = 'other';
        opts.ReflectionGeometry (1,1) string = ''; % only required when SpectralQuantity == "reflectance", see 4.2
        opts.TransmissionGeometry (1,1) string = ''; % only required when SpectralQuantity == "transmittance", see 4.2
        opts.BandwidthFWHM (1,1) double = nan; % not required, written only if not nan
        opts.BandwidthCorrected (1,1) logical = false; 
    end

    ff = fopen(filename,'w');
    if ff < 0
        error('Write_IES_TM27_SPDX_Spectrum: Cannot open %s for writing');
    end
    Manufacturer = 'mft';
    CatalogNumber = 'cat#';
    Description = 'desc';
    DocumentCreator = 'doccreate';
    Laboratory = 'lab';
    UniqueIdentifier = 'unique';
    ReportNumber = 'report #';
    ReportDate = 'report date';
    DocumentCreationDate = '2024-4-19';
    Comments = 'no comment';
    SpectralQuantity = 'relative';
    BandwidthFWHM = 2.0;
    BandwidthCorrected = true;

    try
        fprintf(ff,'<?xml version="1.0"?>\n');
        fprintf(ff,'<?xml-stylesheet type="text/xsl" href="TM-27-14.xsl"?>\n');
        fprintf(ff,'<IESTM2714 xmlns="http://www.ies.org/iestm2714" version="1.0">\n');
        fprintf(ff,'<Header>\n');
        fprintf(ff,'<Manufacturer>%s</Manufacturer>\n',Manufacturer);
        fprintf(ff,'<CatalogNumber>%s</CatalogNumber>\n',CatalogNumber);
        fprintf(ff,'<Description>%s</Description>\n',Description);
        fprintf(ff,'<DocumentCreator>%s</DocumentCreator>\n',DocumentCreator);
        fprintf(ff,'<Laboratory>%s</Laboratory>\n',Laboratory);
        fprintf(ff,'<UniqueIdentifier>%s</UniqueIdentifier>\n',UniqueIdentifier);
        fprintf(ff,'<ReportNumber>%s</ReportNumber>\n',ReportNumber);
        fprintf(ff,'<ReportDate>%s</ReportDate>\n',ReportDate);
        fprintf(ff,'<DocumentCreationDate>%s</DocumentCreationDate>\n',DocumentCreationDate);
        fprintf(ff,'<Comments>%s</Comments>\n',Comments);
        fprintf(ff,'</Header>\n');
        fprintf(ff,'<SpectralDistribution>\n');
        fprintf(ff,'<SpectralQuantity>%s</SpectralQuantity>\n',SpectralQuantity);
        fprintf(ff,'<BandwidthFWHM>%g</BandwidthFWHM>\n',BandwidthFWHM);
        fprintf(ff,'<BandwidthCorrected>%s</BandwidthCorrected>\n',mat2str(BandwidthCorrected));
        for i = 1:length(spec.lam)
            fprintf(ff,'<SpectralData wavelength="%g">%g</SpectralData>\n',spec.lam(i), spec.val(i));
        end
        fprintf(ff,'</SpectralDistribution>\n');
        fprintf(ff,'</IESTM2714>\n');

    catch ME
        fclose(ff);
        rethrow(ME);
        return;
    end
    fclose(ff);

    % example file from the standard

    % <?xml version="1.0"?>
    % <?xml-stylesheet type="text/xsl" href="TM-27-14.xsl"?>
    % <IESTM2714 xmlns="http://www.ies.org/iestm2714" version="1.0">
    % <Header>
    % <Manufacturer>Academy Lighting</Manufacturer>
    % <CatalogNumber>XET 55529</CatalogNumber>
    % <Description>LED 2’ x 4’ Troffer</Description>
    % <DocumentCreator>Apex Analytics</DocumentCreator>
    % <Laboratory>Apex Analytics</Laboratory>
    % <UniqueIdentifier>TS3005k3d96</UniqueIdentifier>
    % <ReportNumber>APEX-091101-004</ReportNumber>
    % <ReportDate>2009-11-01</ReportDate>
    % <DocumentCreationDate>2011-11-21</DocumentCreationDate>
    % <Comments>Ambient temperature 25 degrees C.</Comments>
    % </Header>
    % <SpectralDistribution>
    % <SpectralQuantity>relative</SpectralQuantity>
    % <BandwidthFWHM>2.0</BandwidthFWHM>
    % <BandwidthCorrected>true</BandwidthCorrected>
    % <SpectralData wavelength="400.0">0.47</SpectralData>
    % <SpectralData wavelength="410.0">0.51</SpectralData>
    % <SpectralData wavelength="420.0">0.56</SpectralData>
    % <SpectralData wavelength="430.0">0.61</SpectralData>
    % <SpectralData wavelength="440.0">0.66</SpectralData>
    % <SpectralData wavelength="450.0">0.72</SpectralData>
    % <SpectralData wavelength="460.0">0.76</SpectralData>
    % <SpectralData wavelength="470.0">0.77</SpectralData>
    % <SpectralData wavelength="480.0">0.79</SpectralData>
    % <SpectralData wavelength="490.0">0.81</SpectralData>
    % <SpectralData wavelength="500.0">0.83</SpectralData>
    % <SpectralData wavelength="510.0">0.85</SpectralData>
    % <SpectralData wavelength="520.0">0.88</SpectralData>
    % <SpectralData wavelength="530.0">0.92</SpectralData>
    % <SpectralData wavelength="540.0">0.05</SpectralData>
    % <SpectralData wavelength="550.0">0.99</SpectralData>
    % <SpectralData wavelength="560.0">0.99</SpectralData>
    % <SpectralData wavelength="570.0">1.00</SpectralData>
    % <SpectralData wavelength="580.0">0.95</SpectralData>
    % <SpectralData wavelength="590.0">0.91</SpectralData>
    % <SpectralData wavelength="600.0">0.76</SpectralData>
    % <SpectralData wavelength="610.0">0.62</SpectralData>
    % <SpectralData wavelength="620.0">0.51</SpectralData>
    % <SpectralData wavelength="630.0">0.40</SpectralData>
    % <SpectralData wavelength="640.0">0.29</SpectralData>
    % <SpectralData wavelength="650.0">0.21</SpectralData>
    % </SpectralDistribution>
    % </IESTM2714>

end